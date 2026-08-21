import Sound
import lean_certs.cert_23_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_82_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 23) (d := 82) (c := cert_23_82) (by decide)

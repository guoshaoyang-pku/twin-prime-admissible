import Sound
import lean_certs.cert_22_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_82_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 22) (d := 82) (c := cert_22_82) (by decide)

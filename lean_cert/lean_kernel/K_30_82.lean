import Sound
import lean_certs.cert_30_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_82_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 30) (d := 82) (c := cert_30_82) (by decide)

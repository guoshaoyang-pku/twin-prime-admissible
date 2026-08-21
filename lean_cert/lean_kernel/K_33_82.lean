import Sound
import lean_certs.cert_33_82

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_82_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 82 := by
  exact certValidRoot_sound (k := 33) (d := 82) (c := cert_33_82) (by decide)

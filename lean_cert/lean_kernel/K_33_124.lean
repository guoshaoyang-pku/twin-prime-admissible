import Sound
import lean_certs.cert_33_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_124_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 33) (d := 124) (c := cert_33_124) (by decide)

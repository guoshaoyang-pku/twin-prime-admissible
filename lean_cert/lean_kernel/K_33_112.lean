import Sound
import lean_certs.cert_33_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_112_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 33) (d := 112) (c := cert_33_112) (by decide)

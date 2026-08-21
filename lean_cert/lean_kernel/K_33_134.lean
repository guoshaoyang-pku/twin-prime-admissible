import Sound
import lean_certs.cert_33_134

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_134_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 33) (d := 134) (c := cert_33_134) (by decide)

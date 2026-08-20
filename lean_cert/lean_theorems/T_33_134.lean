import Sound
import lean_certs.cert_33_134

open CertVerify

theorem H33_gt_134 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 33) (d := 134) (c := cert_33_134) (by native_decide)

import Sound
import lean_certs.cert_38_134

open CertVerify

theorem H38_gt_134 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 38) (d := 134) (c := cert_38_134) (by native_decide)

import Sound
import lean_certs.cert_38_170

open CertVerify

theorem H38_gt_170 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 38) (d := 170) (c := cert_38_170) (by native_decide)

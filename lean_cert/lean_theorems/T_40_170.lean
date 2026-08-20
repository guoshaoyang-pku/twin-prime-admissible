import Sound
import lean_certs.cert_40_170

open CertVerify

theorem H40_gt_170 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 40) (d := 170) (c := cert_40_170) (by native_decide)

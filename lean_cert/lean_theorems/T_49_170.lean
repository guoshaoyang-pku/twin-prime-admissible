import Sound
import lean_certs.cert_49_170

open CertVerify

theorem H49_gt_170 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 49) (d := 170) (c := cert_49_170) (by native_decide)

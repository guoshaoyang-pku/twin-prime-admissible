import Sound
import lean_certs.cert_48_170

open CertVerify

theorem H48_gt_170 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 48) (d := 170) (c := cert_48_170) (by native_decide)

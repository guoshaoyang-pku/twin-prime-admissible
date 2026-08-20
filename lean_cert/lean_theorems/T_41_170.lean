import Sound
import lean_certs.cert_41_170

open CertVerify

theorem H41_gt_170 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 41) (d := 170) (c := cert_41_170) (by native_decide)

import Sound
import lean_certs.cert_39_170

open CertVerify

theorem H39_gt_170 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 39) (d := 170) (c := cert_39_170) (by native_decide)

import Sound
import lean_certs.cert_47_170

open CertVerify

theorem H47_gt_170 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 47) (d := 170) (c := cert_47_170) (by native_decide)

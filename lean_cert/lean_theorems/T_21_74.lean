import Sound
import lean_certs.cert_21_74

open CertVerify

theorem H21_gt_74 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 21) (d := 74) (c := cert_21_74) (by native_decide)

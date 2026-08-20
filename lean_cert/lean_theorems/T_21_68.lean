import Sound
import lean_certs.cert_21_68

open CertVerify

theorem H21_gt_68 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 21) (d := 68) (c := cert_21_68) (by native_decide)

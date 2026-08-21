import Sound
import lean_certs.cert_18_68

open CertVerify

theorem H18_gt_68 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 18) (d := 68) (c := cert_18_68) (by native_decide)

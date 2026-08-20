import Sound
import lean_certs.cert_34_68

open CertVerify

theorem H34_gt_68 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 34) (d := 68) (c := cert_34_68) (by native_decide)

import Sound
import lean_certs.cert_34_138

open CertVerify

theorem H34_gt_138 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 138 := by
  exact certValidRoot_sound (k := 34) (d := 138) (c := cert_34_138) (by native_decide)

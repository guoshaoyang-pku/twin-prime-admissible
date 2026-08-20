import Sound
import lean_certs.cert_34_134

open CertVerify

theorem H34_gt_134 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 34) (d := 134) (c := cert_34_134) (by native_decide)

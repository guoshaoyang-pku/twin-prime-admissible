import Sound
import lean_certs.cert_34_154

open CertVerify

theorem H34_gt_154 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 34) (d := 154) (c := cert_34_154) (by native_decide)

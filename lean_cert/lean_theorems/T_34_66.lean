import Sound
import lean_certs.cert_34_66

open CertVerify

theorem H34_gt_66 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 34) (d := 66) (c := cert_34_66) (by native_decide)

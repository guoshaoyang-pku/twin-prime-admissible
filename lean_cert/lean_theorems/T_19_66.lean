import Sound
import lean_certs.cert_19_66

open CertVerify

theorem H19_gt_66 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 19) (d := 66) (c := cert_19_66) (by native_decide)

import Sound
import lean_certs.cert_28_66

open CertVerify

theorem H28_gt_66 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 28) (d := 66) (c := cert_28_66) (by native_decide)

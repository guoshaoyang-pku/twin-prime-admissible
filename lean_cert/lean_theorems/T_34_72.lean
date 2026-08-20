import Sound
import lean_certs.cert_34_72

open CertVerify

theorem H34_gt_72 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 34) (d := 72) (c := cert_34_72) (by native_decide)

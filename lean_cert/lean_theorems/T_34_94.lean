import Sound
import lean_certs.cert_34_94

open CertVerify

theorem H34_gt_94 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 34) (d := 94) (c := cert_34_94) (by native_decide)

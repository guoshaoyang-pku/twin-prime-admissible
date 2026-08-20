import Sound
import lean_certs.cert_34_84

open CertVerify

theorem H34_gt_84 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 34) (d := 84) (c := cert_34_84) (by native_decide)

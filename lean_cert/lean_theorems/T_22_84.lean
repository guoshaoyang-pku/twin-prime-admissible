import Sound
import lean_certs.cert_22_84

open CertVerify

theorem H22_gt_84 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 22) (d := 84) (c := cert_22_84) (by native_decide)

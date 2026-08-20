import Sound
import lean_certs.cert_25_84

open CertVerify

theorem H25_gt_84 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 25) (d := 84) (c := cert_25_84) (by native_decide)

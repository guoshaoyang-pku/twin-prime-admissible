import Sound
import lean_certs.cert_41_84

open CertVerify

theorem H41_gt_84 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 41) (d := 84) (c := cert_41_84) (by native_decide)

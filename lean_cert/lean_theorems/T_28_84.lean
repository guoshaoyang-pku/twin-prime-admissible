import Sound
import lean_certs.cert_28_84

open CertVerify

theorem H28_gt_84 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 28) (d := 84) (c := cert_28_84) (by native_decide)

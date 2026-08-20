import Sound
import lean_certs.cert_37_84

open CertVerify

theorem H37_gt_84 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 37) (d := 84) (c := cert_37_84) (by native_decide)

import Sound
import lean_certs.cert_26_66

open CertVerify

theorem H26_gt_66 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 26) (d := 66) (c := cert_26_66) (by native_decide)

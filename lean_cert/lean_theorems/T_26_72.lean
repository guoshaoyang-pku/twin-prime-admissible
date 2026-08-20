import Sound
import lean_certs.cert_26_72

open CertVerify

theorem H26_gt_72 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 26) (d := 72) (c := cert_26_72) (by native_decide)

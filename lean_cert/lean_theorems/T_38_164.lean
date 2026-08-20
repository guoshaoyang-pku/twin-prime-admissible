import Sound
import lean_certs.cert_38_164

open CertVerify

theorem H38_gt_164 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 38) (d := 164) (c := cert_38_164) (by native_decide)

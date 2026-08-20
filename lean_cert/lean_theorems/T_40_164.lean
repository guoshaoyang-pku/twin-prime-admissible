import Sound
import lean_certs.cert_40_164

open CertVerify

theorem H40_gt_164 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 40) (d := 164) (c := cert_40_164) (by native_decide)

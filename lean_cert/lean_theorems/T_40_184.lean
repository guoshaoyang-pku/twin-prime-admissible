import Sound
import lean_certs.cert_40_184

open CertVerify

theorem H40_gt_184 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 40) (d := 184) (c := cert_40_184) (by native_decide)

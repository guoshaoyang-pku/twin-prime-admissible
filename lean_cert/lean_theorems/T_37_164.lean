import Sound
import lean_certs.cert_37_164

open CertVerify

theorem H37_gt_164 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 37) (d := 164) (c := cert_37_164) (by native_decide)

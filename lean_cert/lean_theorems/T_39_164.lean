import Sound
import lean_certs.cert_39_164

open CertVerify

theorem H39_gt_164 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 39) (d := 164) (c := cert_39_164) (by native_decide)

import Sound
import lean_certs.cert_39_154

open CertVerify

theorem H39_gt_154 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 39) (d := 154) (c := cert_39_154) (by native_decide)

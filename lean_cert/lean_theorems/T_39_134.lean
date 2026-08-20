import Sound
import lean_certs.cert_39_134

open CertVerify

theorem H39_gt_134 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 134 := by
  exact certValidRoot_sound (k := 39) (d := 134) (c := cert_39_134) (by native_decide)

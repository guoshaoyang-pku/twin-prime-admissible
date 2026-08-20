import Sound
import lean_certs.cert_39_162

open CertVerify

theorem H39_gt_162 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 39) (d := 162) (c := cert_39_162) (by native_decide)

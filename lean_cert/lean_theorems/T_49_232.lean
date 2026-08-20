import Sound
import lean_certs.cert_49_232

open CertVerify

theorem H49_gt_232 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 232 := by
  exact certValidRoot_sound (k := 49) (d := 232) (c := cert_49_232) (by native_decide)

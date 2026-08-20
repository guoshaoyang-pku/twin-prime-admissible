import Sound
import lean_certs.cert_48_232

open CertVerify

theorem H48_gt_232 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 232 := by
  exact certValidRoot_sound (k := 48) (d := 232) (c := cert_48_232) (by native_decide)

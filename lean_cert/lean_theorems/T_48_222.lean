import Sound
import lean_certs.cert_48_222

open CertVerify

theorem H48_gt_222 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 222 := by
  exact certValidRoot_sound (k := 48) (d := 222) (c := cert_48_222) (by native_decide)

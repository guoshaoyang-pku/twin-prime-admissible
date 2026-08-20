import Sound
import lean_certs.cert_48_210

open CertVerify

theorem H48_gt_210 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 48) (d := 210) (c := cert_48_210) (by native_decide)

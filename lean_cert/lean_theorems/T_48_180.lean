import Sound
import lean_certs.cert_48_180

open CertVerify

theorem H48_gt_180 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 48) (d := 180) (c := cert_48_180) (by native_decide)

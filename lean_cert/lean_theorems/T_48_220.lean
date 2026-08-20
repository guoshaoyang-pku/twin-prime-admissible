import Sound
import lean_certs.cert_48_220

open CertVerify

theorem H48_gt_220 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 220 := by
  exact certValidRoot_sound (k := 48) (d := 220) (c := cert_48_220) (by native_decide)

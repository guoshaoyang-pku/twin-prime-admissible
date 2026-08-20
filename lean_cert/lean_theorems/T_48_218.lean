import Sound
import lean_certs.cert_48_218

open CertVerify

theorem H48_gt_218 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 218 := by
  exact certValidRoot_sound (k := 48) (d := 218) (c := cert_48_218) (by native_decide)

import Sound
import lean_certs.cert_49_218

open CertVerify

theorem H49_gt_218 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 218 := by
  exact certValidRoot_sound (k := 49) (d := 218) (c := cert_49_218) (by native_decide)

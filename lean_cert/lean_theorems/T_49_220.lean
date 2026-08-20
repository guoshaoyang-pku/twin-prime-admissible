import Sound
import lean_certs.cert_49_220

open CertVerify

theorem H49_gt_220 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 220 := by
  exact certValidRoot_sound (k := 49) (d := 220) (c := cert_49_220) (by native_decide)

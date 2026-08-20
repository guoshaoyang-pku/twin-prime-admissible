import Sound
import lean_certs.cert_49_180

open CertVerify

theorem H49_gt_180 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 49) (d := 180) (c := cert_49_180) (by native_decide)

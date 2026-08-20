import Sound
import lean_certs.cert_41_180

open CertVerify

theorem H41_gt_180 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 41) (d := 180) (c := cert_41_180) (by native_decide)

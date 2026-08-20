import Sound
import lean_certs.cert_39_180

open CertVerify

theorem H39_gt_180 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 39) (d := 180) (c := cert_39_180) (by native_decide)
